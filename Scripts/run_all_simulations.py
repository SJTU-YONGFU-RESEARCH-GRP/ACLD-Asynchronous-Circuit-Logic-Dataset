#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
run_all_simulations.py

Script to run Spectre simulations for all 120 ACLD circuits and collect failure statistics.
"""

import os
import json
import subprocess
import time
from datetime import datetime

class SimulationRunner:
    """Class to run simulations for all ACLD circuits."""

    def __init__(self, dataset_root="../ACLD"):
        self.dataset_root = dataset_root
        if not os.path.exists(self.dataset_root):
            raise ValueError("Dataset directory {} not found".format(dataset_root))

        self.circuit_dirs = [d for d in os.listdir(self.dataset_root)
                           if os.path.isdir(os.path.join(self.dataset_root, d)) and d.endswith("_ACL")]
        print("Found {} circuit directories".format(len(self.circuit_dirs)))

    def get_testbench_files(self, circuit_id):
        """Get testbench files for a circuit."""
        testbenches = []
        for circuit_dir in self.circuit_dirs:
            if circuit_dir.startswith("{}_".format(circuit_id)):
                circuit_path = os.path.join(self.dataset_root, circuit_dir)
                for filename in os.listdir(circuit_path):
                    if filename.startswith("{}_tb".format(circuit_dir)) and filename.endswith('.sp'):
                        testbenches.append(os.path.join(circuit_path, filename))
        return testbenches

    def run_single_simulation(self, testbench_file, timeout=300):
        """Run a single Spectre simulation."""
        if not os.path.exists(testbench_file):
            return {'success': False, 'error': 'Testbench file not found'}

        # Create output directory
        testbench_dir = os.path.dirname(testbench_file)
        output_dir = os.path.join(testbench_dir, 'simulation_results')
        os.makedirs(output_dir, exist_ok=True)

        # Copy testbench file to output directory
        import shutil
        testbench_basename = os.path.basename(testbench_file)
        local_testbench_file = os.path.join(output_dir, testbench_basename)
        shutil.copy2(testbench_file, local_testbench_file)

        # Use Spectre command format as specified by user
        cmd = ['spectre', testbench_basename, '+log', 'sim.log']

        try:
            start_time = time.time()
            result = subprocess.run(
                cmd,
                cwd=output_dir,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                universal_newlines=True,
                timeout=timeout
            )
            end_time = time.time()

            simulation_result = {
                'success': result.returncode == 0,
                'testbench': testbench_file,
                'command': ' '.join(cmd),
                'return_code': result.returncode,
                'execution_time': end_time - start_time,
                'stdout': result.stdout,
                'stderr': result.stderr,
                'output_dir': output_dir
            }

            return simulation_result

        except subprocess.TimeoutExpired:
            return {'success': False, 'error': 'Simulation timeout after {} seconds'.format(timeout)}
        except Exception as e:
            return {'success': False, 'error': str(e)}

    def run_all_simulations(self):
        """Run simulations for all circuits."""
        results = {}
        total_circuits = 120

        print("Starting batch simulation of {} circuits...".format(total_circuits))
        print("Using Spectre command format: spectre <testbench> +log sim.log")
        print("=" * 80)

        successful_simulations = 0
        failed_simulations = 0

        for circuit_id in range(1, total_circuits + 1):
            print("\n" + "="*60)
            print("Circuit #{} Simulation".format(circuit_id))
            print("="*60)

            circuit_results = {
                'circuit_id': circuit_id,
                'tb1': None,
                'tb2': None
            }

            # Get testbench files
            testbenches = self.get_testbench_files(circuit_id)
            if not testbenches:
                print("Circuit #{}: No testbenches found".format(circuit_id))
                circuit_results['error'] = 'No testbenches found'
                results[circuit_id] = circuit_results
                failed_simulations += 1
                continue

            # Run tb1 (transient analysis)
            tb1_files = [tb for tb in testbenches if 'tb1' in os.path.basename(tb)]
            if tb1_files:
                print("Running tb1 (transient) for circuit #{}...".format(circuit_id))
                tb1_result = self.run_single_simulation(tb1_files[0])
                circuit_results['tb1'] = tb1_result

                if tb1_result['success']:
                    print("✓ tb1 successful ({}s)".format(tb1_result['execution_time']))
                    successful_simulations += 1
                else:
                    print("✗ tb1 failed: {}".format(tb1_result.get('error', 'Unknown error')))
                    failed_simulations += 1
            else:
                print("Circuit #{}: No tb1 testbench found".format(circuit_id))
                failed_simulations += 1

            # Run tb2 (DC analysis)
            tb2_files = [tb for tb in testbenches if 'tb2' in os.path.basename(tb)]
            if tb2_files:
                print("Running tb2 (DC) for circuit #{}...".format(circuit_id))
                tb2_result = self.run_single_simulation(tb2_files[0])
                circuit_results['tb2'] = tb2_result

                if tb2_result['success']:
                    print("✓ tb2 successful ({}s)".format(tb2_result['execution_time']))
                    successful_simulations += 1
                else:
                    print("✗ tb2 failed: {}".format(tb2_result.get('error', 'Unknown error')))
                    failed_simulations += 1
            else:
                print("Circuit #{}: No tb2 testbench found".format(circuit_id))
                failed_simulations += 1

            results[circuit_id] = circuit_results

        # Save results to file
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        results_file = "/home/luwangzilu/jiyuxin/ACLD/batch_simulation_results_{}.json".format(timestamp)

        with open(results_file, 'w') as f:
            json.dump(results, f, indent=2, default=str)

        # Print summary
        print("\n" + "="*80)
        print("BATCH SIMULATION RESULTS SUMMARY")
        print("="*80)
        print("Total circuits processed: {}".format(total_circuits))
        print("Total simulations attempted: {}".format(successful_simulations + failed_simulations))
        print("Successful simulations: {}".format(successful_simulations))
        print("Failed simulations: {}".format(failed_simulations))
        print("Success rate: {:.1f}%".format((successful_simulations / (successful_simulations + failed_simulations)) * 100 if (successful_simulations + failed_simulations) > 0 else 0))

        # List failed circuits
        failed_circuits = []
        for circuit_id, result in results.items():
            if (result.get('tb1') and not result['tb1']['success']) or \
               (result.get('tb2') and not result['tb2']['success']) or \
               (not result.get('tb1') and not result.get('tb2')):
                failed_circuits.append(circuit_id)

        print("\nFailed circuits ({}):".format(len(failed_circuits)))
        if failed_circuits:
            for circuit_id in failed_circuits:
                result = results[circuit_id]
                tb1_status = "✓" if result.get('tb1') and result['tb1']['success'] else "✗"
                tb2_status = "✓" if result.get('tb2') and result['tb2']['success'] else "✗"
                print("  Circuit #{}: tb1={}, tb2={}".format(circuit_id, tb1_status, tb2_status))

        print("\nResults saved to: {}".format(results_file))

        return results

def main():
    """Main function."""
    print("ACLD Batch Simulation Runner")
    print("=" * 40)

    try:
        runner = SimulationRunner()
        results = runner.run_all_simulations()

    except Exception as e:
        print("Error in batch simulation: {}".format(e))
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()


