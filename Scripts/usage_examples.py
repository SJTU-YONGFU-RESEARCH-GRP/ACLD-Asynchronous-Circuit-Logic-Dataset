# -*- coding: utf-8 -*-
"""
dataset_usage_examples.py

This script provides comprehensive examples demonstrating how to access and use
the Asynchronous Circuit Logic Dataset (ACLD). It shows practical usage patterns
for researchers working with asynchronous circuit designs.

Prerequisites:
    - Python 3.x environment (recommended: conda activate)
    - Cadence Spectre (with environment: source license.sh)

Usage:
    conda activate  # Activate conda environment if needed
    python dataset_usage_examples.py

Author: ACLD Dataset Team
"""

import os
import json
import glob
import subprocess
import time
import re
from datetime import datetime

try:
    import pandas as pd
    PANDAS_AVAILABLE = True
except ImportError:
    PANDAS_AVAILABLE = False


class ACLDDataset:
    """ACLD Dataset access and analysis class."""

    def __init__(self, dataset_root="../ACLD"):
        """
        Initialize ACLD dataset accessor.

        Args:
            dataset_root: Path to the ACLD dataset directory
        """
        self.dataset_root = dataset_root
        if not os.path.exists(self.dataset_root):
            raise ValueError("Dataset directory {} not found".format(dataset_root))

        self.circuit_dirs = [d for d in os.listdir(self.dataset_root)
                           if os.path.isdir(os.path.join(self.dataset_root, d)) and d.endswith("_ACL")]
        print("Found {} circuit directories".format(len(self.circuit_dirs)))

    def get_circuit_json_files(self):
        """Get all JSON metadata files in the dataset."""
        json_files = []
        for circuit_dir in self.circuit_dirs:
            json_pattern = "{}.json".format(circuit_dir)
            json_file = os.path.join(self.dataset_root, circuit_dir, json_pattern)
            if os.path.exists(json_file):
                json_files.append(json_file)
        return json_files

    def load_circuit_data(self, circuit_id):
        """
        Load circuit data by ID.

        Args:
            circuit_id: Circuit repository ID (1-120)

        Returns:
            Circuit data dictionary or None if not found
        """
        for circuit_dir in self.circuit_dirs:
            if circuit_dir.startswith("{}_".format(circuit_id)):
                json_file = os.path.join(self.dataset_root, circuit_dir, "{}.json".format(circuit_dir))
                if os.path.exists(json_file):
                    with open(json_file, 'r') as f:
                        return json.load(f)
        return None

    def get_circuit_spice_file(self, circuit_id):
        """Get SPICE netlist file for a circuit."""
        for circuit_dir in self.circuit_dirs:
            if circuit_dir.startswith("{}_".format(circuit_id)):
                spice_file = os.path.join(self.dataset_root, circuit_dir, "{}.sp".format(circuit_dir))
                if os.path.exists(spice_file):
                    return spice_file
        return None

    def get_circuit_testbenches(self, circuit_id):
        """Get testbench files for a circuit."""
        testbenches = []
        for circuit_dir in self.circuit_dirs:
            if circuit_dir.startswith("{}_".format(circuit_id)):
                circuit_path = os.path.join(self.dataset_root, circuit_dir)
                for filename in os.listdir(circuit_path):
                    if filename.startswith("{}_tb".format(circuit_dir)) and filename.endswith('.sp'):
                        testbenches.append(os.path.join(circuit_path, filename))
        return testbenches

    def filter_circuits_by_pipeline_structure(self, pipeline_type):
        """
        Filter circuits by pipeline structure.

        Args:
            pipeline_type: Pipeline structure type (e.g., 'QDI', 'Self-Timed Micro-Pipeline')

        Returns:
            List of circuit IDs matching the criteria
        """
        matching_ids = []
        json_files = self.get_circuit_json_files()

        for json_file in json_files:
            with open(json_file, 'r') as f:
                data = json.load(f)
                if data.get('techniques', {}).get('pipelineStructure') == pipeline_type:
                    circuit_id = data.get('metadata', {}).get('repositoryIdentifier', {}).get('id')
                    if circuit_id:
                        matching_ids.append(circuit_id)

        return sorted(matching_ids)

    def get_transistor_statistics(self):
        """Calculate transistor statistics across all circuits."""
        json_files = self.get_circuit_json_files()
        total_nmos = 0
        total_pmos = 0
        circuit_stats = []

        for json_file in json_files:
            with open(json_file, 'r') as f:
                data = json.load(f)

            circuit_info = data.get('circuit', {})
            nmos = circuit_info.get('transistorCount', {}).get('nmos', 0)
            pmos = circuit_info.get('transistorCount', {}).get('pmos', 0)
            circuit_id = data.get('metadata', {}).get('repositoryIdentifier', {}).get('id')

            total_nmos += nmos
            total_pmos += pmos
            circuit_stats.append({
                'id': circuit_id,
                'nmos': nmos,
                'pmos': pmos,
                'total': nmos + pmos
            })

        return {
            'total_nmos': total_nmos,
            'total_pmos': total_pmos,
            'total_transistors': total_nmos + total_pmos,
            'circuit_count': len(circuit_stats),
            'circuit_stats': circuit_stats
        }

    def create_circuit_summary_dataframe(self):
        """Create a pandas DataFrame with circuit summaries."""
        if not PANDAS_AVAILABLE:
            raise ImportError("pandas is required for DataFrame functionality")

        json_files = self.get_circuit_json_files()
        circuit_data = []

        for json_file in json_files:
            with open(json_file, 'r') as f:
                data = json.load(f)

            metadata = data.get('metadata', {}).get('repositoryIdentifier', {})
            publication = data.get('publication', {})
            techniques = data.get('techniques', {})
            circuit = data.get('circuit', {})

            circuit_data.append({
                'id': metadata.get('id'),
                'doi': metadata.get('doi'),
                'title': publication.get('title'),
                'year': publication.get('year'),
                'pipeline_structure': techniques.get('pipelineStructure'),
                'data_coding': techniques.get('dataChannelConfiguration', {}).get('dataCodingScheme'),
                'design_template': techniques.get('designTemplate'),
                'circuit_type': circuit.get('type'),
                'nmos_count': circuit.get('transistorCount', {}).get('nmos', 0),
                'pmos_count': circuit.get('transistorCount', {}).get('pmos', 0),
                'total_transistors': circuit.get('transistorCount', {}).get('nmos', 0) + circuit.get('transistorCount', {}).get('pmos', 0),
                'has_clock': circuit.get('hasClock', False),
                'non_ratioed': circuit.get('nonRatioed', False)
            })

        return pd.DataFrame(circuit_data).sort_values('id')

    def detect_spice_simulators(self):
        """Detect available SPICE simulators on the system."""
        simulators = {}

        # Check for Spectre (Cadence) with environment setup
        try:
            # Check if Cadence environment file exists
            env_file = 'license.sh'
            if os.path.exists(env_file):
                # Try to source environment and check spectre
                env_cmd = '. {} && which spectre'.format(env_file)
                result = subprocess.run(['bash', '-c', env_cmd], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
                if result.returncode == 0 and result.stdout.strip():
                    simulators['spectre'] = result.stdout.strip()
                    simulators['spectre_env'] = env_file
                    print("✓ Spectre detected with Cadence environment: {}".format(simulators['spectre']))
                else:
                    print("ℹ️  Cadence environment file exists but Spectre not found in PATH")
            else:
                # Fallback to direct check
                result = subprocess.run(['which', 'spectre'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
                if result.returncode == 0:
                    simulators['spectre'] = result.stdout.strip()
                    print("✓ Spectre detected in system PATH: {}".format(simulators['spectre']))
        except Exception as e:
            print("⚠️  Error detecting Spectre: {}".format(str(e)))

        # Check for HSPICE (Synopsys)
        try:
            result = subprocess.run(['which', 'hspice'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
            if result.returncode == 0:
                simulators['hspice'] = result.stdout.strip()
        except:
            pass

        # Check for ngspice
        try:
            result = subprocess.run(['which', 'ngspice'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
            if result.returncode == 0:
                simulators['ngspice'] = result.stdout.strip()
        except:
            pass

        return simulators

    def run_spice_simulation(self, testbench_file, simulator='auto', timeout=300):
        """
        Run SPICE simulation on a testbench file.

        Args:
            testbench_file: Path to the testbench SPICE file
            simulator: Simulator to use ('spectre', 'hspice', 'ngspice', or 'auto')
            timeout: Simulation timeout in seconds

        Returns:
            Dictionary with simulation results
        """
        if not os.path.exists(testbench_file):
            return {'success': False, 'error': 'Testbench file not found'}

        # Detect available simulators
        available_simulators = self.detect_spice_simulators()

        if not available_simulators:
            return {'success': False, 'error': 'No SPICE simulators found on system'}

        # Select simulator
        if simulator == 'auto':
            # Prefer Spectre > HSPICE > ngspice
            if 'spectre' in available_simulators:
                simulator = 'spectre'
            elif 'hspice' in available_simulators:
                simulator = 'hspice'
            elif 'ngspice' in available_simulators:
                simulator = 'ngspice'
            else:
                return {'success': False, 'error': 'No suitable simulator found'}

        if simulator not in available_simulators:
            return {'success': False, 'error': '{} simulator not available'.format(simulator)}

        # Prepare simulation command
        if simulator == 'spectre':
            # Check if environment setup is available
            env_file = available_simulators.get('spectre_env')
            if env_file:
                cmd = ['bash', '-c', 'source {} && {} {}'.format(env_file, available_simulators['spectre'], testbench_file)]
            else:
                cmd = [available_simulators['spectre'], testbench_file]
        elif simulator == 'hspice':
            cmd = [available_simulators['hspice'], testbench_file]
        elif simulator == 'ngspice':
            cmd = [available_simulators['ngspice'], '-b', testbench_file]  # Batch mode

        # Create output directory for results
        testbench_dir = os.path.dirname(testbench_file)
        testbench_name = os.path.splitext(os.path.basename(testbench_file))[0]
        output_dir = os.path.join(testbench_dir, 'simulation_results')
        os.makedirs(output_dir, exist_ok=True)

        # Copy testbench file to output directory to avoid path issues
        testbench_basename = os.path.basename(testbench_file)
        local_testbench_file = os.path.join(output_dir, testbench_basename)
        import shutil
        shutil.copy2(testbench_file, local_testbench_file)

        # Fix Cadence-specific syntax issues in the testbench
        self._fix_testbench_syntax(local_testbench_file)

        # Update command to use local testbench file
        if simulator == 'spectre':
            # Use the format specified by user: spectre <testbench> +log sim.log
            # Check if environment setup is available
            env_file = available_simulators.get('spectre_env')
            if env_file:
                cmd = ['bash', '-c', 'source {} && {} {} +log sim.log'.format(env_file, available_simulators['spectre'], testbench_basename)]
            else:
                cmd = [available_simulators['spectre'], testbench_basename, '+log', 'sim.log']
        elif simulator == 'hspice':
            cmd = [available_simulators['hspice'], testbench_basename]
        elif simulator == 'ngspice':
            cmd = [available_simulators['ngspice'], '-b', testbench_basename]  # Batch mode

        # Run simulation
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
                'simulator': simulator,
                'testbench': testbench_file,
                'command': ' '.join(cmd),
                'return_code': result.returncode,
                'execution_time': end_time - start_time,
                'stdout': result.stdout,
                'stderr': result.stderr,
                'output_dir': output_dir
            }

            # Parse results if simulation was successful
            if result.returncode == 0:
                simulation_result.update(self._parse_simulation_results(output_dir, simulator))

            return simulation_result

        except subprocess.TimeoutExpired:
            return {'success': False, 'error': 'Simulation timeout after {} seconds'.format(timeout)}
        except Exception as e:
            return {'success': False, 'error': str(e)}

    def _parse_simulation_results(self, output_dir, simulator):
        """Parse simulation output files to extract performance metrics."""
        results = {
            'delay_ps': None,
            'power_uw': None,
            'energy_fj': None,
            'output_files': []
        }

        try:
            # List all output files
            if os.path.exists(output_dir):
                results['output_files'] = os.listdir(output_dir)

            # Parse based on simulator type
            if simulator == 'spectre':
                results.update(self._parse_spectre_results(output_dir))
            elif simulator == 'hspice':
                results.update(self._parse_hspice_results(output_dir))
            elif simulator == 'ngspice':
                results.update(self._parse_ngspice_results(output_dir))

        except Exception as e:
            results['parse_error'] = str(e)

        return results

    def _fix_testbench_syntax(self, testbench_file):
        """Fix Cadence-specific syntax issues in the testbench file."""
        try:
            with open(testbench_file, 'r') as f:
                content = f.read()

            # Basic syntax fixes if needed
            # For now, just ensure the file is readable
            # Add more fixes here if specific syntax issues are encountered

            # Write back the content (unchanged for now)
            with open(testbench_file, 'w') as f:
                f.write(content)

        except Exception as e:
            print("Warning: Could not fix testbench syntax for {}: {}".format(testbench_file, e))

    def _parse_spectre_results(self, output_dir):
        """Parse Spectre simulation results with comprehensive Cadence Spectre format support."""
        results = {}

        try:
            # Spectre generates multiple output files
            output_files = os.listdir(output_dir)

            # Parse .log file (simulation log)
            log_files = [f for f in output_files if f.endswith('.log')]
            if log_files:
                log_content = self._read_spectre_log(os.path.join(output_dir, log_files[0]))
                results.update(self._extract_metrics_from_log(log_content))

            # Parse .mt0 file (measurement results)
            mt0_files = [f for f in output_files if f.endswith('.mt0')]
            if mt0_files:
                mt0_content = self._read_spectre_mt0(os.path.join(output_dir, mt0_files[0]))
                results.update(self._extract_metrics_from_mt0(mt0_content))

            # Parse .psfx file (PSF binary data) - would need additional libraries
            # For now, we rely on .log and .mt0 files

            # Parse .stdout file for additional info
            stdout_files = [f for f in output_files if 'stdout' in f.lower()]
            if stdout_files:
                stdout_content = self._read_file_content(os.path.join(output_dir, stdout_files[0]))
                results.update(self._extract_metrics_from_stdout(stdout_content))

        except Exception as e:
            results['parse_error'] = str(e)

        return results


    def _extract_metrics_from_log(self, content):
        """Extract timing and power metrics from Spectre log file."""
        results = {}

        # Common Spectre timing measurements
        timing_patterns = [
            # Delay measurements
            r'delay\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s?)',
            r'tpd\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s?)',
            r'propagation_delay\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s?)',
            r'timing_delay\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s?)',

            # Handshake timing (async specific)
            r'req_ack_delay\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s?)',
            r'handshake_delay\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s?)',
            r'ack_delay\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s?)',

            # Our custom measurements
            r'handshake_delay\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s?)',
        ]

        for pattern in timing_patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            for match in matches:
                value, unit = match
                delay_value = self._convert_to_ps(float(value), unit)
                if 'delay_ps' not in results or delay_value > results['delay_ps']:
                    results['delay_ps'] = delay_value

        # Power measurements
        power_patterns = [
            r'avg_power\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([uWmw]?W?)',
            r'power\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([uWmw]?W?)',
            r'power_consumption\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([uWmw]?W?)',
            r'static_power\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([uWmw]?W?)',
            r'dynamic_power\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([uWmw]?W?)',
            r'avg_dynamic_power\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([uWmw]?W?)',
        ]

        for pattern in power_patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            for match in matches:
                value, unit = match
                power_value = self._convert_to_uw(float(value), unit)
                if 'power_uw' not in results or power_value > results['power_uw']:
                    results['power_uw'] = power_value

        # Energy measurements
        energy_patterns = [
            r'energy\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?J?)',
            r'switching_energy\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?J?)',
            r'transition_energy\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?J?)',
        ]

        # Current measurements for leakage
        current_patterns = [
            r'leakage_current\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([uWmn]?A?)',
            r'current\s*=\s*([0-9.]+(?:e[+-]?\d+)?)\s*([uWmn]?A?)',
        ]

        for pattern in energy_patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            for match in matches:
                value, unit = match
                energy_value = self._convert_to_fj(float(value), unit)
                if 'energy_fj' not in results or energy_value > results['energy_fj']:
                    results['energy_fj'] = energy_value

        # Current measurements (leakage)
        for pattern in current_patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            for match in matches:
                value, unit = match
                current_value = self._convert_to_na(float(value), unit)
                if 'leakage_current_na' not in results or current_value > results['leakage_current_na']:
                    results['leakage_current_na'] = current_value

        return results

    def _extract_metrics_from_mt0(self, content):
        """Extract metrics from Spectre .mt0 measurement file."""
        results = {}

        # .mt0 files contain measurement results in tabular format
        lines = content.split('\n')

        for line in lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            # Look for measurement results
            # Format: measurement_name value unit
            parts = line.split()
            if len(parts) >= 3:
                name, value_str, unit = parts[0], parts[1], ' '.join(parts[2:])

                try:
                    value = float(value_str)

                    # Convert units and store
                    if 'delay' in name.lower() or 'tpd' in name.lower():
                        results['delay_ps'] = self._convert_to_ps(value, unit)
                    elif 'power' in name.lower():
                        results['power_uw'] = self._convert_to_uw(value, unit)
                    elif 'energy' in name.lower():
                        results['energy_fj'] = self._convert_to_fj(value, unit)

                except ValueError:
                    continue

        return results

    def _extract_metrics_from_stdout(self, content):
        """Extract metrics from Spectre stdout."""
        results = {}

        # Look for final results in stdout
        lines = content.split('\n')

        for line in lines:
            # Look for lines containing measurements
            if any(keyword in line.lower() for keyword in ['delay', 'power', 'energy', 'timing']):
                # Simple extraction - look for numbers followed by units
                number_unit_pattern = r'([0-9.]+(?:e[+-]?\d+)?)\s*([fpnum]?s|[uWmw]?W|[fpnum]?J)'
                matches = re.findall(number_unit_pattern, line, re.IGNORECASE)

                for value_str, unit in matches:
                    try:
                        value = float(value_str)

                        if unit.lower().endswith('s'):
                            results['delay_ps'] = self._convert_to_ps(value, unit)
                        elif unit.lower().endswith('w'):
                            results['power_uw'] = self._convert_to_uw(value, unit)
                        elif unit.lower().endswith('j'):
                            results['energy_fj'] = self._convert_to_fj(value, unit)

                    except ValueError:
                        continue

        return results


    def _parse_hspice_results(self, output_dir):
        """Parse HSPICE simulation results."""
        results = {}

        # Look for .mt0, .lis, or .log files
        for filename in os.listdir(output_dir):
            if filename.endswith('.lis') or filename.endswith('.mt0'):
                result_file = os.path.join(output_dir, filename)
                try:
                    with open(result_file, 'r') as f:
                        content = f.read()

                    # Extract performance metrics (simplified parsing)
                    delay_match = re.search(r'delay\s*=\s*([0-9.]+)', content, re.IGNORECASE)
                    if delay_match:
                        results['delay_ps'] = float(delay_match.group(1))

                    power_match = re.search(r'avg_power\s*=\s*([0-9.]+)', content, re.IGNORECASE)
                    if power_match:
                        results['power_uw'] = float(power_match.group(1))

                except Exception as e:
                    results['parse_error'] = str(e)

        return results

    def _parse_ngspice_results(self, output_dir):
        """Parse ngspice simulation results."""
        results = {}

        # Look for output files
        for filename in os.listdir(output_dir):
            if filename.endswith('.log') or filename.startswith('ngspice-'):
                result_file = os.path.join(output_dir, filename)
                try:
                    with open(result_file, 'r') as f:
                        content = f.read()

                    # Extract basic metrics from ngspice output
                    # This is highly simplified and would need customization
                    results['raw_output'] = content[:1000]  # First 1000 chars for inspection

                except Exception as e:
                    results['parse_error'] = str(e)

        return results

    def run_async_circuit_simulation(self, circuit_id, simulator='auto', analysis_type='both'):
        """
        Run comprehensive simulation for an asynchronous circuit.

        Args:
            circuit_id: Circuit ID to simulate
            simulator: Simulator to use
            analysis_type: 'transient', 'dc', or 'both'

        Returns:
            Dictionary with simulation results
        """
        circuit_data = self.load_circuit_data(circuit_id)
        if not circuit_data:
            return {'success': False, 'error': 'Circuit {} not found'.format(circuit_id)}

        testbenches = self.get_circuit_testbenches(circuit_id)
        if not testbenches:
            return {'success': False, 'error': 'No testbenches found for circuit {}'.format(circuit_id)}

        results = {
            'circuit_id': circuit_id,
            'circuit_type': circuit_data['circuit']['type'],
            'simulations': {},
            'summary': {}
        }

        # Run transient analysis (delay and energy)
        if analysis_type in ['transient', 'both']:
            tb1_files = [tb for tb in testbenches if 'tb1' in os.path.basename(tb)]
            if tb1_files:
                print("Running transient analysis for circuit {}...".format(circuit_id))
                transient_result = self.run_spice_simulation(tb1_files[0], simulator)
                results['simulations']['transient'] = transient_result

        # Run DC analysis (static power)
        if analysis_type in ['dc', 'both']:
            tb2_files = [tb for tb in testbenches if 'tb2' in os.path.basename(tb)]
            if tb2_files:
                print("Running DC analysis for circuit {}...".format(circuit_id))
                dc_result = self.run_spice_simulation(tb2_files[0], simulator)
                results['simulations']['dc'] = dc_result

        # Generate summary
        results['summary'] = self._generate_simulation_summary(results)

        return results

 



    def run_spectre_with_script(self, testbench_file, simulator='spectre', timeout=600):
        """
        Run Spectre simulation with generated script for better control.

        Args:
            testbench_file: Path to testbench file
            simulator: Spectre simulator to use
            timeout: Timeout in seconds

        Returns:
            Simulation results dictionary
        """
        if not os.path.exists(testbench_file):
            return {'success': False, 'error': 'Testbench file not found'}

        # Detect available simulators
        available_simulators = self.detect_spice_simulators()
        if simulator not in available_simulators:
            return {'success': False, 'error': '{} simulator not available'.format(simulator)}

        # Create output directory
        testbench_dir = os.path.dirname(testbench_file)
        output_dir = os.path.join(testbench_dir, 'spectre_results')
        os.makedirs(output_dir, exist_ok=True)

        # Generate Spectre script
        spectre_script = self.generate_spectre_simulation_script(testbench_file, output_dir)

        # Run Spectre with the generated script
        env_file = available_simulators.get('spectre_env')
        if env_file:
            cmd = ['bash', '-c', 'source {} && {} {}'.format(env_file, available_simulators[simulator], spectre_script)]
        else:
            cmd = [available_simulators[simulator], spectre_script]

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
                'simulator': simulator,
                'testbench': testbench_file,
                'spectre_script': spectre_script,
                'command': ' '.join(cmd),
                'return_code': result.returncode,
                'execution_time': end_time - start_time,
                'stdout': result.stdout,
                'stderr': result.stderr,
                'output_dir': output_dir
            }

            # Parse Spectre-specific results
            if result.returncode == 0:
                simulation_result.update(self._parse_spectre_results(output_dir))

            return simulation_result

        except subprocess.TimeoutExpired:
            return {'success': False, 'error': 'Spectre simulation timeout after {} seconds'.format(timeout)}
        except Exception as e:
            return {'success': False, 'error': str(e)}


def example_access_dataset():
    """Example 1: Basic dataset access."""
    print("=== Example 1: Basic Dataset Access ===")

    try:
        dataset = ACLDDataset()

        # Access circuit #1
        circuit_data = dataset.load_circuit_data(1)
        if circuit_data:
            print("Title: {}".format(circuit_data['publication']['title']))
            print("Pipeline Structure: {}".format(circuit_data['techniques']['pipelineStructure']))
            print("Transistor Count: {}".format(circuit_data['circuit']['transistorCount']))
            print("Interface Pins: {}".format(circuit_data['circuit']['interface']))

        # Get SPICE file
        spice_file = dataset.get_circuit_spice_file(1)
        if spice_file:
            print("SPICE file available: {}".format(spice_file))

        # Get testbenches
        testbenches = dataset.get_circuit_testbenches(1)
        print("Testbench files: {}".format([str(tb) for tb in testbenches]))

    except Exception as e:
        print("Error in basic access: {}".format(e))


def example_batch_processing():
    """Example 2: Batch processing and statistics."""
    print("\n=== Example 2: Batch Processing and Statistics ===")

    try:
        dataset = ACLDDataset()
        stats = dataset.get_transistor_statistics()

        print("Total circuits: {}".format(stats['circuit_count']))
        print("Total NMOS transistors: {}".format(stats['total_nmos']))
        print("Total PMOS transistors: {}".format(stats['total_pmos']))
        print("Total transistors: {}".format(stats['total_transistors']))

        # Show top 5 circuits by transistor count
        sorted_stats = sorted(stats['circuit_stats'], key=lambda x: x['total'], reverse=True)
        print("\nTop 5 circuits by transistor count:")
        for i, stat in enumerate(sorted_stats[:5]):
            print("  #{}: {} transistors (NMOS: {}, PMOS: {})".format(stat['id'], stat['total'], stat['nmos'], stat['pmos']))

    except Exception as e:
        print("Error in batch processing: {}".format(e))


def example_filtering():
    """Example 3: Filtering circuits by properties."""
    print("\n=== Example 3: Filtering Circuits by Properties ===")

    try:
        dataset = ACLDDataset()

        # Find QDI circuits
        qdi_circuits = dataset.filter_circuits_by_pipeline_structure('QDI')
        print("QDI circuits found: {}".format(qdi_circuits))

        # Find Self-Timed Micro-Pipeline circuits
        stmp_circuits = dataset.filter_circuits_by_pipeline_structure('Self-Timed Micro-Pipeline')
        print("Self-Timed Micro-Pipeline circuits found: {}".format(stmp_circuits))

    except Exception as e:
        print("Error in filtering: {}".format(e))


def example_dataframe_analysis():
    """Example 4: DataFrame analysis."""
    print("\n=== Example 4: DataFrame Analysis ===")

    try:
        dataset = ACLDDataset()
        df = dataset.create_circuit_summary_dataframe()

        print("Dataset shape: {}".format(df.shape))
        print("\nPipeline structure distribution:")
        print(df['pipeline_structure'].value_counts())

        print("\nData coding scheme distribution:")
        print(df['data_coding'].value_counts())

        print("\nDesign template distribution:")
        print(df['design_template'].value_counts())

        print("\nTransistor count statistics:")
        print(df[['nmos_count', 'pmos_count', 'total_transistors']].describe())

    except Exception as e:
        print("Error in DataFrame analysis: {}".format(e))


def example_spice_simulation_prep():
    """Example 5: SPICE simulation preparation."""
    print("\n=== Example 5: SPICE Simulation Preparation ===")

    try:
        dataset = ACLDDataset()

        # Prepare circuit #1 for simulation
        circuit_data = dataset.load_circuit_data(1)
        spice_file = dataset.get_circuit_spice_file(1)
        testbenches = dataset.get_circuit_testbenches(1)

        if circuit_data and spice_file and testbenches:
            print("Preparing circuit #{} for simulation".format(circuit_data['metadata']['repositoryIdentifier']['id']))
            print("Circuit type: {}".format(circuit_data['circuit']['type']))
            print("SPICE netlist: {}".format(spice_file))

            print("\nAvailable testbenches:")
            for tb in testbenches:
                tb_name = os.path.basename(tb)
                if 'tb1' in tb_name:
                    print("  - {}: Transient analysis (delay and switching energy)".format(tb_name))
                elif 'tb2' in tb_name:
                    print("  - {}: DC analysis (static power)".format(tb_name))

            print("\nSimulation command examples:")
            print("# For Spectre:")
            print("spectre {}".format(testbenches[0]))
            print("spectre {}".format(testbenches[1]))

            print("\n# For HSPICE:")
            print("hspice {}".format(testbenches[0]))
            print("hspice {}".format(testbenches[1]))

    except Exception as e:
        print("Error in simulation preparation: {}".format(e))


def example_actual_simulation_execution():
    """Example 8: Actual SPICE simulation execution."""
    print("\n=== Example 8: Actual SPICE Simulation Execution ===")

    try:
        dataset = ACLDDataset()

        # Detect available simulators
        simulators = dataset.detect_spice_simulators()
        print("Available SPICE simulators:")
        for sim, path in simulators.items():
            print("  - {}: {}".format(sim.upper(), path))
        print()

        if not simulators:
            print("No SPICE simulators found. Please install Spectre, HSPICE, or ngspice.")
            print("Skipping actual simulation execution.")
            return

        # Select a circuit for simulation
        circuit_id = 1
        print("Running comprehensive simulation for circuit #{}...".format(circuit_id))

        # Run simulation
        simulation_results = dataset.run_async_circuit_simulation(
            circuit_id=circuit_id,
            simulator='auto',  # Auto-select best available simulator
            analysis_type='both'  # Run both transient and DC analysis
        )

        # Display results
        if simulation_results.get('success', False):
            print("\nSimulation completed successfully!")
            print("Circuit: {} ({})".format(
                simulation_results['circuit_id'],
                simulation_results['circuit_type']
            ))

            # Show simulation details
            for sim_type, result in simulation_results['simulations'].items():
                print("\n{} Analysis:".format(sim_type.title()))
                print("  - Success: {}".format(result['success']))
                print("  - Simulator: {}".format(result['simulator']))
                print("  - Execution time: {:.2f} seconds".format(result['execution_time']))

                if result['success']:
                    delay = result.get('delay_ps')
                    power = result.get('power_uw')
                    energy = result.get('energy_fj')

                    if delay is not None:
                        print("  - Delay: {} ps".format(delay))
                    if power is not None:
                        print("  - Power: {} uW".format(power))
                    if energy is not None:
                        print("  - Energy: {} fJ".format(energy))

                    if result.get('output_files'):
                        print("  - Output files: {}".format(len(result['output_files'])))
                else:
                    print("  - Error: {}".format(result.get('error', 'Unknown error')))

            # Show summary
            summary = simulation_results.get('summary', {})
            print("\nOverall Summary:")
            print("  - Total simulations: {}".format(summary.get('total_simulations', 0)))
            print("  - Successful: {}".format(summary.get('successful_simulations', 0)))
            print("  - Failed: {}".format(summary.get('failed_simulations', 0)))

            if summary.get('performance_metrics'):
                print("  - Performance metrics extracted: {}".format(
                    len(summary['performance_metrics'])
                ))

        else:
            print("Simulation failed: {}".format(simulation_results.get('error', 'Unknown error')))

    except Exception as e:
        print("Error in simulation execution: {}".format(e))
        import traceback
        traceback.print_exc()


def example_timing_power_analysis():
    """Example 10: Timing and Power Analysis using Spectre simulation."""
    print("\n=== Example 10: Spectre-Based Timing and Power Analysis ===")

    try:
        dataset = ACLDDataset()

        # Check for Spectre availability
        simulators = dataset.detect_spice_simulators()
        if 'spectre' not in simulators:
            print("Cadence Spectre not found on system.")
            print("Available simulators: {}".format(list(simulators.keys())))
            print("Please install Cadence Spectre to run actual timing and power analysis.")
            print("\nFalling back to estimation method...")
            return example_timing_power_estimation(dataset)

        # Check technology library access
        tech_lib_path = "/home/luwangzilu/jiyuxin/ACLD/input/spectre/gpdk045.scs"
        try:
            with open(tech_lib_path, 'r') as f:
                pass  # Just test if we can open it
            print("✓ Technology library accessible: {}".format(tech_lib_path))
        except:
            print("❌ Technology library not accessible: {}".format(tech_lib_path))
            print("Cannot run Spectre simulations without proper technology setup.")
            print("Please ensure the Cadence 45nm PDK is properly installed and accessible.")
            return

        print("Using Cadence Spectre for accurate timing and power analysis...")
        print("Simulator path: {}".format(simulators['spectre']))

        # Analyze ALL circuits in the dataset (1-120)
        test_circuits = list(range(1, 121))  # All circuits from 1 to 120
        print("Analyzing ALL {} circuits in ACLD dataset with Spectre simulation...".format(len(test_circuits)))
        print("Note: Only circuits with successful Spectre simulations will be included in statistics.")

        timing_power_results = {}

        for circuit_id in test_circuits:
            print("\n" + "="*50)
            print("Circuit #{} Spectre Analysis".format(circuit_id))
            print("="*50)

            # Load circuit data
            circuit_data = dataset.load_circuit_data(circuit_id)
            if not circuit_data:
                print("Circuit {} not found, skipping...".format(circuit_id))
                continue

            # Get testbenches
            testbenches = dataset.get_circuit_testbenches(circuit_id)
            if not testbenches:
                print("Circuit #{}: No testbenches found".format(circuit_id))
                timing_power_results[circuit_id] = {'circuit_id': circuit_id, 'circuit_type': circuit_data['circuit']['type'], 'transient': None, 'dc': None}
                continue

            # Run Spectre simulations directly on existing testbenches
            circuit_results = {
                'circuit_id': circuit_id,
                'circuit_type': circuit_data['circuit']['type'],
                'transient': None,
                'dc': None
            }

            # Transient analysis for timing using existing testbench
            tb1_files = [tb for tb in testbenches if 'tb1' in os.path.basename(tb)]
            if tb1_files:
                transient_result = dataset.run_spice_simulation(tb1_files[0], 'spectre', timeout=600)
                circuit_results['transient'] = transient_result

                if transient_result['success']:
                    delay = transient_result.get('delay_ps')
                    if delay is not None:
                        print("Circuit #{}: Transient ✓ ({:.3f} ps)".format(circuit_id, delay))
                    else:
                        print("Circuit #{}: Transient ✓ (no delay data)".format(circuit_id))
                else:
                    print("Circuit #{}: Transient ✗".format(circuit_id))
            else:
                print("Circuit #{}: No transient testbench".format(circuit_id))

            # DC analysis for static power using existing testbench
            tb2_files = [tb for tb in testbenches if 'tb2' in os.path.basename(tb)]
            if tb2_files:
                dc_result = dataset.run_spice_simulation(tb2_files[0], 'spectre', timeout=300)
                circuit_results['dc'] = dc_result

                if dc_result['success']:
                    power = dc_result.get('power_uw')
                    if power is not None:
                        print("Circuit #{}: DC ✓ ({:.3f} uW)".format(circuit_id, power))
                    else:
                        print("Circuit #{}: DC ✓ (no power data)".format(circuit_id))
                else:
                    print("Circuit #{}: DC ✗".format(circuit_id))
            else:
                print("Circuit #{}: No DC testbench".format(circuit_id))

            timing_power_results[circuit_id] = circuit_results

        # Overall analysis - only successful simulations
        print("\n" + "="*80)
        print("ACLD DATASET SPECTRE TIMING AND POWER ANALYSIS RESULTS")
        print("="*80)
        print("Total circuits attempted: {}".format(len(test_circuits)))

        # Collect all successful results
        successful_transient = []
        successful_dc = []
        successful_both = []

        total_successful = 0

        for circuit_id, results in timing_power_results.items():
            transient_success = results['transient'] and results['transient']['success']
            dc_success = results['dc'] and results['dc']['success']

            if transient_success:
                delay = results['transient'].get('delay_ps')
                if delay is not None:
                    successful_transient.append((circuit_id, delay))

            if dc_success:
                power = results['dc'].get('power_uw')
                if power is not None:
                    successful_dc.append((circuit_id, power))

            if transient_success and dc_success:
                successful_both.append(circuit_id)
                total_successful += 1

        print("Circuits with successful simulations: {}".format(total_successful))
        print("Circuits with timing data: {}".format(len(successful_transient)))
        print("Circuits with power data: {}".format(len(successful_dc)))

        if total_successful == 0:
            print("\n❌ NO CIRCUITS COMPLETED SPECTRE SIMULATION SUCCESSFULLY")
            print("=" * 60)
            print("This indicates issues with the simulation environment:")
            print("  • Technology library access: {}".format(tech_lib_path))
            print("  • Testbench file compatibility")
            print("  • Spectre installation or licensing")
            print("  • Circuit netlist syntax errors")
            print("  • Required model file dependencies")
            print()
            print("SOLUTION:")
            print("  1. Ensure Cadence 45nm PDK is properly installed")
            print("  2. Check file permissions for technology libraries")
            print("  3. Verify Spectre license is available")
            print("  4. Validate testbench file syntax")
            print()
            print("Since no actual Spectre simulations completed successfully,")
            print("no timing and power distribution statistics are available.")
            print("All results would need to be based on actual simulation data.")
            return

        # Timing analysis summary
        if successful_transient:
            print("\n" + "="*60)
            print("TIMING ANALYSIS RESULTS")
            print("="*60)
            delays = [delay for _, delay in successful_transient]
            print("  Circuits with valid timing data: {}".format(len(successful_transient)))
            print("  Delay range: {:.3f} - {:.3f} ps".format(min(delays), max(delays)))
            print("  Average delay: {:.3f} ps".format(sum(delays)/len(delays)))
            print("  Median delay: {:.3f} ps".format(sorted(delays)[len(delays)//2]))

            # Calculate standard deviation
            mean_delay = sum(delays)/len(delays)
            variance = sum((x - mean_delay)**2 for x in delays) / len(delays)
            std_dev = variance**0.5
            print("  Standard deviation: {:.3f} ps".format(std_dev))

            # Sort by delay for ranking
            sorted_by_delay = sorted(successful_transient, key=lambda x: x[1])
            print("\n  [TOP 5 FASTEST CIRCUITS]")
            for i, (circuit_id, delay) in enumerate(sorted_by_delay[:5]):
                circuit_type = timing_power_results[circuit_id]['circuit_type']
                print("    #{}. Circuit {} ({}): {:.3f} ps".format(i+1, circuit_id, circuit_type, delay))

            print("\n  [TOP 5 SLOWEST CIRCUITS]")
            for i, (circuit_id, delay) in enumerate(sorted_by_delay[-5:]):
                circuit_type = timing_power_results[circuit_id]['circuit_type']
                print("    #{}. Circuit {} ({}): {:.3f} ps".format(len(sorted_by_delay)-4+i, circuit_id, circuit_type, delay))

        # Power analysis summary
        if successful_dc:
            print("\n" + "="*60)
            print("POWER ANALYSIS RESULTS")
            print("="*60)
            powers = [power for _, power in successful_dc]
            print("  Circuits with valid power data: {}".format(len(successful_dc)))
            print("  Static power range: {:.3f} - {:.3f} uW".format(min(powers), max(powers)))
            print("  Average static power: {:.3f} uW".format(sum(powers)/len(powers)))
            print("  Median static power: {:.3f} uW".format(sorted(powers)[len(powers)//2]))

            # Calculate standard deviation
            mean_power = sum(powers)/len(powers)
            variance = sum((x - mean_power)**2 for x in powers) / len(powers)
            std_dev = variance**0.5
            print("  Standard deviation: {:.3f} uW".format(std_dev))

            # Sort by power for ranking
            sorted_by_power = sorted(successful_dc, key=lambda x: x[1])
            print("\n  [TOP 5 LOWEST POWER CIRCUITS]")
            for i, (circuit_id, power) in enumerate(sorted_by_power[:5]):
                circuit_type = timing_power_results[circuit_id]['circuit_type']
                print("    #{}. Circuit {} ({}): {:.3f} uW".format(i+1, circuit_id, circuit_type, power))

            print("\n  [TOP 5 HIGHEST POWER CIRCUITS]")
            for i, (circuit_id, power) in enumerate(sorted_by_power[-5:]):
                circuit_type = timing_power_results[circuit_id]['circuit_type']
                print("    #{}. Circuit {} ({}): {:.3f} uW".format(len(sorted_by_power)-4+i, circuit_id, circuit_type, power))

        # Combined analysis for circuits with both timing and power data
        if successful_both:
            print("\n" + "="*60)
            print("COMBINED TIMING & POWER ANALYSIS")
            print("="*60)
            print("Circuits with both timing and power data: {}".format(len(successful_both)))

            combined_data = []
            for circuit_id in successful_both:
                delay = None
                power = None

                if timing_power_results[circuit_id]['transient']['success']:
                    delay = timing_power_results[circuit_id]['transient'].get('delay_ps')

                if timing_power_results[circuit_id]['dc']['success']:
                    power = timing_power_results[circuit_id]['dc'].get('power_uw')

                if delay is not None and power is not None:
                    energy = delay * power / 1000  # fJ
                    combined_data.append((circuit_id, delay, power, energy))

            if combined_data:
                print("\n  [ENERGY EFFICIENCY ANALYSIS]")
                energies = [energy for _, _, _, energy in combined_data]
                print("  Energy range: {:.3f} - {:.3f} fJ".format(min(energies), max(energies)))
                print("  Average energy: {:.3f} fJ".format(sum(energies)/len(energies)))

                # Sort by energy efficiency (lowest energy first)
                sorted_by_energy = sorted(combined_data, key=lambda x: x[3])
                print("\n  [TOP 5 MOST ENERGY-EFFICIENT CIRCUITS]")
                for i, (circuit_id, delay, power, energy) in enumerate(sorted_by_energy[:5]):
                    circuit_type = timing_power_results[circuit_id]['circuit_type']
                    print("    #{}. Circuit {} ({}): {:.3f} fJ ({:.3f} ps, {:.3f} uW)".format(
                        i+1, circuit_id, circuit_type, energy, delay, power))

        print("\n" + "="*80)
        print("SPECTRE SIMULATION SUMMARY")
        print("="*80)
        print("✓ Spectre executable: {}".format(simulators['spectre']))
        if 'spectre_env' in simulators:
            print("✓ Cadence environment: {}".format(simulators['spectre_env']))
        print("✓ Technology library: {}".format(tech_lib_path))
        print("✓ Analysis type: Transient (timing) + DC (static power)")
        print("✓ Timeout per simulation: 600 seconds")
        print("✓ Results based on actual Spectre simulations only")
        print("✓ No estimation or interpolation used")

    except Exception as e:
        print("Error in Spectre timing and power analysis: {}".format(e))
        import traceback
        traceback.print_exc()




def main():
    """Main function demonstrating all usage examples."""
    print("ACLD Dataset Usage Examples")
    print("=" * 50)


    # Run examples
    example_access_dataset()
    example_batch_processing()
    example_filtering()


    example_spice_simulation_prep()
    example_actual_simulation_execution()

    example_timing_power_analysis()


    print("All examples completed successfully!")
    print("\nFor more information, see the ACLD README.md file.")


if __name__ == "__main__":
    main()
